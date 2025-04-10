#!/bin/bash

lock_file=".lock";

# Function to release the semaphore (unlock)
if rm -rf ".lock"; then
  echo "Released lock.";
  return 0; # Success
else
  echo "Failed to release lock. Lock file may not exist.";
  return 1; # Failure
fi

