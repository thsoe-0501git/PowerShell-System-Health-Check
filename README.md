# PowerShell: Automated Windows System Health Check

## Project Goal
A small PowerShell script designed for rapid diagnostics of Windows workstations and servers in 1st-level IT support.
The script automates repetitive routine checks and generates a timestamped report ready for support ticket documentation.

## Features
* **System Inventory:** Retrieves the hostname and operating system version via CIM/WMI.
* **Resource Monitoring:** Calculates current RAM usage as a percentage.
* **Storage Check:** Inspects drive `C:` and automatically triggers a warning if free disk space drops below 20%.
* **Network Check:** Verifies external connectivity using an ICMP ping (`Test-Connection`).
* **Automated Logging:** Exports the full report as a timestamped UTF-8 text file.
