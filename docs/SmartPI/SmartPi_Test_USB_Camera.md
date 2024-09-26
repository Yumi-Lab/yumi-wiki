# Testing USB Camera on Smart Pi One

![USB Camera - Smart PI One](../../img/SmartPi/SmartPi_Test_USB_Camera/SmartPi_Test_USB_Camera_1.png)


This page provides instructions for testing a USB camera connected to Smart Pi One on an Armbian Debian system. The camera should be connected to the `/dev/video1` source. We will provide examples using both Python and C, with step-by-step instructions for installing the necessary packages and creating the test scripts.

Before proceeding, ensure the camera is connected and the `/dev/video1` source is available by running:

```bash
ls /dev/video*
```

---

## 1. **Linux Commands for Camera Testing**

Before running the test programs, ensure the camera is recognized and accessible:

- Verify the camera is recognized using `v4l2-ctl`:

  ```bash
  sudo apt-get update
  sudo apt-get install v4l-utils
  v4l2-ctl --list-devices
  ```

- To test recording video using `ffmpeg`:

  ```bash
  sudo apt-get install ffmpeg
  ```

  Once installed, you can use the following command to capture video from the camera and save it to a file:

  ```bash
  ffmpeg -f v4l2 -i /dev/video1 -c:v libx264 -preset ultrafast output.mp4
  ```

  This command captures video from `/dev/video1`, encodes it using H.264 (`libx264`), and saves it as `output.mp4`.

- If you see `/dev/video1` in the output of the `v4l2-ctl` command, you can proceed to the Python or C sections.

---

## 2. **Python Camera Test**

### Install the Required Packages

Before running the Python script, install the necessary OpenCV package:

```bash
sudo apt-get update
sudo apt-get install python3-opencv
```

### Create the Python Test Script

1. Use the `nano` editor to create the Python script:

   ```bash
   nano camera_test.py
   ```

2. Add the following Python code to capture a frame from the USB camera:

   ```python
   import cv2

   # Open the camera
   cap = cv2.VideoCapture('/dev/video1')

   if not cap.isOpened():
       print("Error: Could not open video device")
       exit()

   # Set camera parameters (optional)
   cap.set(cv2.CAP_PROP_FRAME_WIDTH, 640)
   cap.set(cv2.CAP_PROP_FRAME_HEIGHT, 480)

   # Capture a single frame
   ret, frame = cap.read()

   if not ret:
       print("Error: Could not read frame")
       exit()

   # Save the captured frame to a file
   cv2.imwrite('captured_frame.jpg', frame)

   # Release the camera
   cap.release()
   ```

3. Save and exit by pressing `Ctrl + X`, then `Y`, and `Enter`.

### Run the Python Test Script

Run the script to capture an image from the camera:

```bash
python3 camera_test.py
```

The image will be saved as `captured_frame.jpg` in the current directory.

---

## 3. **C Camera Test**

### Install the Required Packages

For the C test, you will need OpenCV development libraries:

```bash
sudo apt-get update
sudo apt install libopencv-dev
```

### Create the C Test Program

1. Use `nano` to create the C program:

   ```bash
   nano camera_test.c
   ```

2. Add the following C code to capture a frame from the USB camera:

   ```c
   #include <opencv2/opencv.hpp>
   #include <iostream>

   using namespace cv;
   using namespace std;

   int main() {
       // Open the camera
       VideoCapture cap("/dev/video1");

       if (!cap.isOpened()) {
           cout << "Error: Could not open video device" << endl;
           return -1;
       }

       // Set camera parameters (optional)
       cap.set(CAP_PROP_FRAME_WIDTH, 640);
       cap.set(CAP_PROP_FRAME_HEIGHT, 480);

       Mat frame;
       // Capture a single frame
       bool ret = cap.read(frame);

       if (!ret) {
           cout << "Error: Could not read frame" << endl;
           return -1;
       }

       // Save the captured frame to a file
       imwrite("captured_frame.jpg", frame);

       // Release the camera
       cap.release();

       return 0;
   }
   ```

3. Save and exit by pressing `Ctrl + X`, then `Y`, and `Enter`.

### Compile the C Program

Compile the program using the following command:

```bash
g++ camera_test.c -o camera_test `pkg-config --cflags --libs opencv4`
```

### Run the C Program

Run the program to capture an image from the camera:

```bash
./camera_test
```

The image will be saved as `captured_frame.jpg` in the current directory.

