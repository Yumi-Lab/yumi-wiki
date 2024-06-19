# 1.3 How to change password on Smartpad (Yumios)

To change your password on smartpad using SSH (Secure Shell), you can follow these steps. This tutorial assumes you have already set up SSH access to your Smartpad and can connect to it.

### What You Need:

1. **SSH Client**: If you're on Windows, you can use PuTTY or Windows Subsystem for Linux. On macOS or Linux, you can use the terminal.

2. **Smartpad's IP address**: You need to know the IP address of your Smartpad to connect to it.

3. **Username: `pi` and Password: `yumi`**

### 1 Connect to Smartpad via SSH

- **Windows**: [PuTTY](https://github.com/Yumi-Lab/yumi-wiki/blob/main/docs/KlipperSmartPad/SmartPad_connect_ssh.md#method-2-using-windows-10-built-in-ssh)[Terminal](https://github.com/Yumi-Lab/yumi-wiki/blob/main/docs/KlipperSmartPad/SmartPad_connect_ssh.md#method-2-using-windows-10-built-in-ssh)

- **Linux**: [Terminal](https://github.com/Yumi-Lab/yumi-wiki/blob/main/docs/KlipperSmartPad/SmartPad_connect_ssh.md#123-linux)

- **macOS**: [Terminal](https://github.com/Yumi-Lab/yumi-wiki/blob/main/docs/KlipperSmartPad/SmartPad_connect_ssh.md#122-mac)


### 2. Changing the Password

Once logged in:
- Run the command:

```
`passwd`
```

- You will be prompted to enter the current password once more.

![change_password_smartpad_1](../../img/KlipperSmartPad/Change_password/change_password_smartpad_1.png)

- Then, you'll be asked to enter the new password. Type the new password and press `Enter`.

![change_password_smartpad_2](../../img/KlipperSmartPad/Change_password/change_password_smartpad_2.png)

- You'll need to retype the new password for confirmation. Enter it again and press Enter.

The system will update the password and confirm back with **`passwd: password updated successfully`** or a similar message.

### 3. Test the New Password

It’s a good practice to test the new password:
- Exit the SSH session by typing **`exit`**.
- Reconnect using SSH with the new password to ensure it works correctly.

