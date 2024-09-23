# 1.3 How to change password

To change your password on smartpad using SSH (Secure Shell), you can follow these steps. This tutorial assumes you have already set up SSH access to your Smartpad and can connect to it.

### What You Need:

1. **SSH Client**: If you're on Windows, you can use [PuTTY](https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html) or Windows Subsystem for Linux. On macOS or Linux, you can use the terminal.

2. **Smartpad's IP address**: You need to know the IP address of your Smartpad to connect to it.

3. **Username: `pi` and Password: `yumi`**

### 1. Connect to Smartpad via SSH

- **Windows**: [PuTTY](https://wiki.yumi-lab.com/KlipperSmartPad/SmartPad_connect_ssh/) - [Terminal](https://wiki.yumi-lab.com/KlipperSmartPad/SmartPad_connect_ssh/)

- **Linux**: [Terminal](https://wiki.yumi-lab.com/KlipperSmartPad/SmartPad_connect_ssh/)

- **macOS**: [Terminal](https://wiki.yumi-lab.com/KlipperSmartPad/SmartPad_connect_ssh/)


### 2. Changing the Password

- Once logged in, enter the command:

```
`passwd`
```

- You will be prompted to enter the current password once more.

![change_password_smartpad_1](../img/KlipperSmartPad/Change_password/change_password_smartpad_1.png)

- Then, you'll be asked to enter the new password. Type the new password and press `Enter`.

![change_password_smartpad_2](../img/KlipperSmartPad/Change_password/change_password_smartpad_2.png)

- You'll need to retype the new password for confirmation. Enter it again and press Enter.

The system will update the password and confirm back with **`passwd: password updated successfully`** or a similar message.


