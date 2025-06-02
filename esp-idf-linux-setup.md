# Setup esp idf asahi

Install python3.11

```sh
sudo dnf install python3.11
```

Follow this guide
https://docs.espressif.com/projects/esp-idf/en/stable/esp32/get-started/linux-macos-setup.html

Before install patch python detect script:

```diff
diff --git a/tools/detect_python.sh b/tools/detect_python.sh
index bc3e65c59a..e0d1ed7e81 100644
--- a/tools/detect_python.sh
+++ b/tools/detect_python.sh
@@ -12,7 +12,7 @@ OLDEST_PYTHON_SUPPORTED_MINOR=8
 
 ESP_PYTHON=python
 
-for p_cmd in python3 python python3.8 python3.9 python3.10 python3.11 python3.12; do
+for p_cmd in python3.11; do
     $p_cmd --version >/dev/null 2>&1 || continue
     echo "Checking \"$p_cmd\" ..."
```

After install get permissions to board port e.g.:

```sh
sudo usermod -aG dialout $USER
```

And reboot, logout didnt worked for me :(
