#!/bin/bash

GROUP_NAME="developers"
USER1="student1"
USER2="student2"

echo "Running tests..."

# Clean previous setup
sudo groupdel "$GROUP_NAME" 2>/dev/null || true
sudo userdel "$USER1" 2>/dev/null || true
sudo userdel "$USER2" 2>/dev/null || true

# Create users required for testing
sudo useradd "$USER1"
sudo useradd "$USER2"

# Check commands
grep -Eq '\bgroupadd\b' starter.sh || {
    echo "FAIL: groupadd command not found"
    exit 1
}

grep -Eq '\busermod\b' starter.sh || {
    echo "FAIL: usermod command not found"
    exit 1
}

# Run student program
sudo bash starter.sh

# Check group
if ! getent group "$GROUP_NAME" >/dev/null; then
    echo "FAIL: Group was not created"
    exit 1
fi

# Check users
if ! id -nG "$USER1" | grep -qw "$GROUP_NAME"; then
    echo "FAIL: $USER1 was not added to the group"
    exit 1
fi

if ! id -nG "$USER2" | grep -qw "$GROUP_NAME"; then
    echo "FAIL: $USER2 was not added to the group"
    exit 1
fi

echo "PASS: Group created successfully"
echo "PASS: Both users assigned successfully"
echo "ALL TESTS PASSED!"

# Cleanup
sudo groupdel "$GROUP_NAME" 2>/dev/null || true
sudo userdel "$USER1" 2>/dev/null || true
sudo userdel "$USER2" 2>/dev/null || true
