
Copy `SOURCE` to `DEST`.

### Options

- `-a, --archive`: Same as `-dR --preserve=all`.
- `-b`: Like `--backup` but does not accept an argument.
- `-f, --force`: If an existing destination file cannot be opened, remove it and try again.
- `-i, --interactive`: Prompt before overwrite.
- `-p`: Same as `--preserve=mode,ownership,timestamps`.
- `-r, --recursive`: Copy directories recursively.
- `-v, --verbose`: Explain what is being done.
- `-u, --update`: Copy only when the SOURCE file is newer than the destination file or when the destination file is missing.
- `-h, --help`: Display this help and exit.

## Progress Bar

The script displays a progress bar indicating the percentage of completion while copying files. This feature enhances user experience by providing visual feedback during long copy operations.

## Dependencies

This script relies on basic bash functionalities and does not require any external dependencies.

## Example

To copy a file named `source_file.txt` to a destination named `destination_file.txt`, you can use the following command:

