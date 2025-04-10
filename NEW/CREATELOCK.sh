#!/bin/bash

lock_file=".lock";

# Function to acquire the semaphore (lock)
if mkdir "$lock_file"; then
  echo "Acquired lock.";
  return 0 # Success;
else
  echo "Failed to acquire lock. Another process may be holding it.";
  return 1 # Failure;
fi

