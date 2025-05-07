 #!/bin/bash
ConcatJCL() {
  if [ $# -lt 2 ]; then
    echo "Usage: concatenate_files <output_file> <input_file1> [<input_file2> ...]"
    return 1
  fi

  output_file="$1"
  shift

  cat "$@" > "$output_file"
}