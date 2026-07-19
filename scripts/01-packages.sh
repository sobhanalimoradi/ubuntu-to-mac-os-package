#!/bin/bash
# APT + Flatpak packages installed during macOS-styling setup
set -e

echo "==> Installing APT packages..."
sudo apt-get update
sudo apt-get install -y gnome-sushi fonts-inter nodejs npm

echo "==> Ensuring Flathub remote is configured..."
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

echo "==> Installing Sober (community Roblox client)..."
flatpak install -y flathub org.vinegarhq.Sober

echo "01-packages.sh done."
