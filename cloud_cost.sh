#!/usr/bin/env bash
###############################################################################
# Script Name   : jenkins_build_logs_to_s3.sh
#
# Description   :
#   This script scans Jenkins job build directories and uploads build console
#   logs to Amazon S3 in a clean, structured hierarchy. It supports nested
#   Jenkins folders and organizes logs by job name and date to avoid a flat,
#   messy upload structure.
#
#   S3 structure:
#     s3://<bucket>/jenkins-logs/<job-path>/<YYYY-MM-DD>/<build-number>.log
#
# Author        : Mohammad Furqan Ali
# Role          : DevOps / Cloud Engineer
#
# Version       : 1.0.0
# Created On    : 2026-01-21
#
# Requirements  :
#   - Jenkins (filesystem access to JENKINS_HOME)
#   - AWS CLI configured with valid credentials
#   - Bash 4+
#
# Usage         :
#   Run manually:
#     ./jenkins_build_logs_to_s3.sh
#
#   Or via cron (example):
#     0 23 * * * /path/jenkins_build_logs_to_s3.sh
#
# Notes         :
#   - Only build logs modified today are uploaded
#   - Script exits immediately on error (set -euo pipefail)
#   - Permission warnings from protected paths are avoided by path scoping
#
###############################################################################

set -euo pipefail

# =========================
# Configuration
# =========================
JENKINS_HOME="/var/lib/jenkins"                  # Jenkins home directory
S3_BUCKET="s3://your-s3-bucket-name"              # Target S3 bucket
S3_PREFIX="jenkins-logs"                          # Top-level S3 folder
DATE="$(date +%F)"                                 # Current date (YYYY-MM-DD)

# =========================
# Pre-flight Checks
# =========================
if ! command -v aws >/dev/null 2>&1; then
  echo "ERROR: AWS CLI is not installed or not in PATH."
  exit 1
fi

JOBS_DIR="$JENKINS_HOME/jobs"
if [ ! -d "$JOBS_DIR" ]; then
  echo "ERROR: Jenkins jobs directory not found: $JOBS_DIR"
  exit 1
fi

# =========================
# Helper Functions
# =========================

# Converts Jenkins nested job paths into clean S3 paths
# Example:
#   /var/lib/jenkins/jobs/Folder/jobs/SubJob/builds
#   -> Folder/SubJob
job_s3_path_from_builds_dir() {
  local builds_dir="$1"
  local job_dir

  job_dir="$(dirname "$builds_dir")"
  local rel="${job_dir#"$JOBS_DIR/"}"

  # Remove repeated "jobs" path segments used by Jenkins folders
  echo "$rel" | sed 's#/jobs/#/#g'
}

# =========================
# Main Logic
# =========================

# Locate all Jenkins "builds" directories (supports nested folders)
find "$JOBS_DIR" -type d -name builds -print0 | while IFS= read -r -d '' builds_dir; do
  job_s3_path="$(job_s3_path_from_builds_dir "$builds_dir")"

  # Iterate over individual build directories
  find "$builds_dir" -mindepth 1 -maxdepth 1 -type d -print0 | while IFS= read -r -d '' build_dir; do
    build_number="$(basename "$build_dir")"
    log_file="$build_dir/log"

    # Upload only logs created or modified today
    if [ -f "$log_file" ] && [ "$(date -r "$log_file" +%F)" = "$DATE" ]; then
      dest="$S3_BUCKET/$S3_PREFIX/$job_s3_path/$DATE/$build_number.log"

      if aws s3 cp "$log_file" "$dest" --only-show-errors; then
        echo "SUCCESS: Uploaded $job_s3_path build $build_number"
      else
        echo "ERROR:   Failed to upload $job_s3_path build $build_number"
      fi
    fi
  done
done
