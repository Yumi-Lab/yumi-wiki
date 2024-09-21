# 1.5 How to change password

To change your password on Smart Pi One using SSH (Secure Shell), you can follow these steps. This tutorial assumes you have already set up SSH access to your Smart Pi One and can connect to it.

## What You Need:

1. **SSH Client**: If you're on Windows, you can use [PuTTY](https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html) or Windows Subsystem for Linux. On macOS or Linux, you can use the terminal.

2. **Smart Pi One's IP address**: You need to know the IP address of your Smart Pi One to connect to it.

3. **Username: `root` and Password: `your_smartpione_password`**

## 1. Connect to Smart Pi One via SSH

- **Windows**: [PuTTY](https://wiki.yumi-lab.com/SmartPI/SmartPi_Connect_Ssh/) - [Terminal](https://wiki.yumi-lab.com/SmartPI/SmartPi_Connect_Ssh/)

- **Linux**: [Terminal](https://wiki.yumi-lab.com/SmartPI/SmartPi_Connect_Ssh/)

- **macOS**: [Terminal](https://wiki.yumi-lab.com/SmartPI/SmartPi_Connect_Ssh/)


## 2. Changing the Password

- Once logged in, enter the command:

```
`passwd`
```

- You will be prompted to enter the current password once more.

- Then, you'll be asked to enter the new password. Type the new password and press **`Enter`**.

- You'll need to retype the new password for confirmation. Enter it again and press **`Enter`**.

The system will update the password and confirm back with **`passwd: password updated successfully`** or a similar message.


