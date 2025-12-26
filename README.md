# L90 CPU Fix

<div align="center">

![Version](https://img.shields.io/badge/Version-1.0-blue.svg)
![Platform](https://img.shields.io/badge/platform-Windows-lightgrey.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)

**CPU optimization tool for Frostbite Engine games**

[Download](https://github.com/ToastcodeDev/NFS_Heat_CPU_Load_FIX/releases)

</div>

---

## 🎮 Compatible Games

This fix resolves high CPU usage (90-100%) issues in Frostbite Engine games:

- **Need for Speed Unbound**
- **Need for Speed Heat**
- **Other Frostbite-based titles**

## ✨ Features

- **Automatic CPU Detection** - Instantly detects your processor's cores and threads
- **Manual Override** - Enter specifications manually if auto-detection fails
- **User-Friendly** - Clean interface with intuitive navigation

## 🚀 Quick Start

### Installation

1. **Download** the latest `L90_CPU_Fix.cmd` from our [releases page](https://github.com/ToastcodeDev/NFS_Heat_CPU_Load_FIX/releases)
2. **Copy** the file to your game's root directory
3. **Run** `L90_CPU_Fix.cmd` (right-click → Run as Administrator if needed)
4. **Follow** the on-screen prompts:
   - CPU detection runs automatically
   - Select your game folder via the file browser
   - Configuration file is generated instantly
5. **Launch** your game and experience smoother performance! 🎮

## 🔧 How It Works

The script generates a `user.cfg` file with optimized thread allocation settings:

```ini
Thread.ProcessorCount [your cores]
Thread.MaxProcessorCount [your cores]
Thread.MinFreeProcessorCount 0
Thread.JobThreadPriority 0
GstRender.Thread.MaxProcessorCount [your threads]
```

### Example Configuration

**Intel Core i7-7920HQ** (4 cores, 8 threads):

```ini
Thread.ProcessorCount 4
Thread.MaxProcessorCount 4
Thread.MinFreeProcessorCount 0
Thread.JobThreadPriority 0
GstRender.Thread.MaxProcessorCount 8
```

## ⚙️ Configuration

Settings are stored in `properties.cfg`:

| Parameter | Options | Description |
|-----------|---------|-------------|
| `LANGUAGE` | `EN` / `ES` | Interface language |
| `DEBUG` | `0` / `1` | Debug mode toggle |
| `VERSION` | `1.0` | Script version |


## 📋 Requirements

- **OS**: Windows
- **PowerShell**: Pre-installed on Windows
- **Permissions**: Administrator rights for some game directories

## ❓ Troubleshooting

<details>
<summary><strong>CPU detection fails</strong></summary>

- The script automatically prompts for manual input
- Enter your processor's core and thread count
- Ensure threads ≥ cores (e.g., 6 cores with 12 threads is valid)

</details>

<details>
<summary><strong>File creation fails</strong></summary>

- Verify write permissions in the game folder
- Run the script as Administrator
- Confirm the game directory path is correct

</details>

<details>
<summary><strong>Game doesn't recognize the config</strong></summary>

- Ensure `user.cfg` is in the correct game root folder
- Check if your antivirus quarantined the file
- Verify the game supports custom configuration files

</details>

## 🙏 Credits

Original concept inspired by [NFS Heat CPU Load FIX](https://github.com/Octanium91/NFS_Heat_CPU_Load_FIX)

## 📄 License

This project is open source and free to use under the MIT License.



<div align="center">

**Made with ❤️ for the gaming community**

</div>