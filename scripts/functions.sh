#--- functions ---#

# get_user_input: get user input with a prompt and default value
get_user_input() {
    local prompt="$1"
    local default="$2"
    local -a valid_values=("${@:3}")
    local is_valid=false

    while true; do
        echo

        # Show the prompt along with valid values if any
        if [ ${#valid_values[@]} -eq 0 ]; then
            echo "$prompt"
        else
            echo "$prompt (allowed: ${valid_values[*]})"
        fi
        read -p "Enter (Default: $default): " input

        # Use default value if input is empty
        if [[ -z "$input" ]]; then
            input="$default"
            echo "No input provided. Using default value: '$default'"
            break
        fi

        # Skip validation if no valid values are provided
        if [ ${#valid_values[@]} -eq 0 ]; then
            break
        fi

        # Check if the input is among the valid values
        for value in "${valid_values[@]}"; do
            if [[ "$input" == "$value" ]]; then
                is_valid=true
                break
            fi
        done

        if [[ "$is_valid" == true ]]; then
            break  # Exit the loop if input is valid
        else
            echo
            echo "Invalid input. Please enter one of the allowed values: ${valid_values[*]}"
            echo
        fi
    done
}

# append a new line; the the line exists, delete it first
append_line() {
    local line="$1"
    local file="$2"
    local escaped_line

    # Escape forward slashes in the variable 'line' for use in the sed command
    escaped_line=$(printf '%s\n' "$line" | sed 's:[][\/.^$*]:\\&:g')

    # Use sed to delete all lines that exactly match 'line' from '.bash_aliases'
    sed -i "/^$escaped_line\$/d" "$file"

    # Append 'line' to the end of '.bash_aliases'
    echo "$line" >> "$file"

}

# update the system
update_system() {
    sudo apt-get update
    sudo apt-get upgrade -y
    sudo apt-get install libaio-dev libxml2-dev -y
}
