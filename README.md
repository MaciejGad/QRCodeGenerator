# QRCodeGenerator
<img src="icon.png" alt="AppBrowser Icon" width="200px">

## Local QR Code Generator

This project allows you to generate QR codes locally on your machine. It provides a simple and efficient way to create QR codes without relying on online services.

### Usage

To generate a QR code, use the following command in your terminal:

```bash
bin/qrCodeGenerator https://maciejgad.pl ~/qr.png
```

This command will create a QR code for the URL `https://maciejgad.pl` and save it as `qr.png` in your home directory. You can replace the URL and the output file path as needed.

### Opening QR Code

If you want to open the generated QR code in Preview immediately after creating it, you can use the `qr.sh` script. This script simplifies the process by generating the QR code and opening it in Preview with a single command. Use the following command in your terminal:

```bash
qr.sh https://maciejgad.pl
```

Replace `https://maciejgad.pl` with the URL you want to encode in the QR code. The script will generate the QR code and open it in Preview for you to view.

### Building from Source

If you prefer to build the QRCodeGenerator project from source, you can do so using Xcode. Building from source allows you to customize the project and make any necessary modifications. Follow these steps to build the project from source:

1. Ensure you have Xcode installed on your machine. You can download it from the Mac App Store if you don't have it already.
2. Open the QRCodeGenerator project in Xcode by double-clicking the `.xcodeproj` file or using the `File > Open` menu in Xcode.
3. Select your target device or simulator from the toolbar at the top of the Xcode window.
4. Click on the "Build" button in the toolbar or press `Cmd + B` on your keyboard to start the build process.
5. Wait for Xcode to compile the project. Once the build is complete, the necessary binaries will be generated in the project's build directory.

After building the project, you can use the generated binaries to create QR codes as described in the usage section. This approach gives you full control over the build process and allows you to make any desired changes to the project.

### Watching Changes in Folder

You can set up a watcher that will trigger QR code generation whenever you add a `.webloc` file (drag and drop from Safari address bar) to the `CreateQR` folder. Follow these steps to set up the watcher:

1. Install `fswatch` by running: `brew install fswatch`.
2. Run `./update_watch_plist.sh` to update the path to `watch.sh` in `pl.maciejgad.qrCode.watch.plist`.
3. Move the plist file to the `~/Library/LaunchAgents` folder with the command: `mv pl.maciejgad.qrCode.watch.plist ~/Library/LaunchAgents/`.
4. Load the agent in Terminal with: `launchctl load ~/Library/LaunchAgents/pl.maciejgad.qrCode.watch.plist`. Your script will now run every time you log in.
5. To unload the agent later, use: `launchctl unload ~/Library/LaunchAgents/pl.maciejgad.qrCode.watch.plist`.

By following these steps, you can automate the QR code generation process and ensure that it runs seamlessly in the background.

All steps in one place:
```bash
brew install fswatch
./update_watch_plist.sh
mv pl.maciejgad.qrCode.watch.plist ~/Library/LaunchAgents/
launchctl load ~/Library/LaunchAgents/pl.maciejgad.qrCode.watch.plist
```