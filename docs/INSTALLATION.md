# ProTek v999 - Instalacja | Installation

## Automatyczna instalacja | Automatic Installation

### Linux (Ubuntu/Debian)

```bash
#!/bin/bash
# ProTek v999 Installation Script

echo "🚀 ProTek v999 - Starting Installation"
echo "📅 $(date)"

# Check system requirements
if [[ "$(uname -m)" != "x86_64" ]]; then
    echo "❌ Unsupported architecture. x86_64 required."
    exit 1
fi

# Update system packages
echo "📦 Updating system packages..."
sudo apt update && sudo apt upgrade -y

# Install Docker if not present
if ! command -v docker &> /dev/null; then
    echo "🐳 Installing Docker..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo usermod -aG docker $USER
    rm get-docker.sh
fi

# Pull required Docker images
echo "📥 Pulling Docker images..."
docker pull ghcr.io/railwayapp-templates/postgres-ssl:latest

echo "✅ ProTek v999 installation completed!"
echo "🎉 Ready to use!"
```

## Manualna instalacja | Manual Installation

### Wymagania systemowe | System Requirements

- **Architektura:** x86_64
- **System operacyjny:** Ubuntu 20.04+ lub Debian 11+
- **RAM:** Minimum 2GB
- **Miejsce na dysku:** Minimum 5GB
- **Docker:** Wersja 20.10+

### Kroki instalacji | Installation Steps

1. **Sklonuj repozytorium | Clone repository:**
   ```bash
   git clone https://github.com/Fervv268/ProTek_v999.git
   cd ProTek_v999
   ```

2. **Zainstaluj Docker | Install Docker:**
   ```bash
   curl -fsSL https://get.docker.com -o get-docker.sh
   sudo sh get-docker.sh
   ```

3. **Uruchom ProTek | Run ProTek:**
   ```bash
   ./scripts/install.sh
   ```

## Rozwiązywanie problemów | Troubleshooting

### Częste problemy | Common Issues

- **Brak uprawnień sudo:** Skontaktuj się z administratorem systemu
- **Błąd architektury:** ProTek v999 wymaga architektury x86_64
- **Problemy z Docker:** Sprawdź czy Docker daemon jest uruchomiony

### Logi | Logs

Logi instalacji znajdują się w katalogu `logs/`:
```bash
tail -f logs/protek_build_*.log
```