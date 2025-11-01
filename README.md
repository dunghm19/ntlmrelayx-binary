# ntlmrelayx - Standalone Binary Builder

Build a standalone, portable binary of **ntlmrelayx** from Impacket for penetration testing and security assessments.

## Quick Start

### Build the Binary

**Using the build script:**
```bash
# Linux/Mac
chmod +x build-binary.sh
./build-binary.sh

# Windows (Git Bash or WSL)
bash build-binary.sh
```

**Manual build:**
```bash
# Build Docker image
docker build -t ntlmrelayx-builder .

# Extract binary
docker create --name temp ntlmrelayx-builder
docker cp temp:/usr/local/bin/ntlmrelayx ./ntlmrelayx
docker rm temp

# Make executable (Linux/Mac)
chmod +x ./ntlmrelayx
```

### Run the Binary

```bash
./ntlmrelayx [options]
```

The binary is standalone and includes all dependencies - no Python or Impacket installation required.

## Troubleshooting

### GLIBC Version Error

If you encounter an error like:
```
version `GLIBC_2.38' not found
```

This means your system's GLIBC is older than the one the binary was compiled with. The binary is built with Python latest image (typically GLIBC 2.31+), so your system needs at least that version.

**Solutions:**
1. **Check your GLIBC version**: `ldd --version`
2. **Use a compatible system**: The binary requires GLIBC 2.31 or higher
3. **Build on your target system**: Run the build script directly on the target machine if Docker is available
4. **Use Docker**: `docker run ntlmrelayx-builder` runs the binary in a container