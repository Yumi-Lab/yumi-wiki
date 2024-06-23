# 1.4 How to change password on Smart Pi One

To change your password on Smart Pi One using SSH (Secure Shell), you can follow these steps. This tutorial assumes you have already set up SSH access to your Smart Pi One and can connect to it.

## What You Need:

1. **SSH Client**: If you're on Windows, you can use [PuTTY](https://www.putty.org/) or Windows Subsystem for Linux. On macOS or Linux, you can use the terminal.

2. **Smart Pi One's IP address**: You need to know the IP address of your Smart Pi One to connect to it.

3. **Username: `root` and Password: `your_smartpione_password`**

## 1. Connect to Smart Pi One via SSH

- **Windows**: [PuTTY](https://github.com/Yumi-Lab/yumi-wiki/blob/main/docs/SmartPI/SmartPI_Connect_Ssh.md#windows-with-putty) - [Terminal](https://github.com/Yumi-Lab/yumi-wiki/blob/main/docs/SmartPI/SmartPI_Connect_Ssh.md#windows-terminal-command-prompt-or-powershell)

- **Linux**: [Terminal](https://github.com/Yumi-Lab/yumi-wiki/blob/main/docs/SmartPI/SmartPI_Connect_Ssh.md#linux-terminal)

- **macOS**: [Terminal](https://github.com/Yumi-Lab/yumi-wiki/blob/main/docs/SmartPI/SmartPI_Connect_Ssh.md#macos-terminal)


## 2. Changing the Password

Once logged in:
- Run the command:

```
`passwd`
```

- You will be prompted to enter the current password once more.

- Then, you'll be asked to enter the new password. Type the new password and press **`Enter`**.

- You'll need to retype the new password for confirmation. Enter it again and press **`Enter`**.

The system will update the password and confirm back with **`passwd: password updated successfully`** or a similar message.

## 3. Test the New Password

It’s a good practice to test the new password:
- Exit the SSH session by typing **`exit`**.
- Reconnect using SSH with the new password to ensure it works correctly.

