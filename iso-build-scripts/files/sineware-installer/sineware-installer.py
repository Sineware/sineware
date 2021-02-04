#!/usr/bin/env python3
#  Copyright (C) 2020 Seshan Ravikumar
#
#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program.  If not, see <https://www.gnu.org/licenses/>.
#import urllib.request
#import json
from subprocess import Popen, PIPE, STDOUT
import os

print("-------------------------------------------------------------------")
print("Welcome to the Sineware EL Server installer for x86 (BIOS)!")
print("This release is intended as a TECH PREVIEW!")
print()
print("""Copyright (C) 2020 Seshan Ravikumar
    This program comes with ABSOLUTELY NO WARRANTY.
    This is free software, and you are welcome to redistribute it
    under the conditions of the GNU GPLv3 or later.""")
print("-------------------------------------------------------------------")

print("Block detected and available on the system:")
os.system("lsblk")
print()

install_disk = input("Enter the target disk (ex. /dev/sda): ")
if install_disk == "":
    print("No disk specified. Exiting... (No changes have been made)")
    exit(-1)
print("Installing to " + install_disk)

# """ print("Contacting the update server...", end='', flush=True)
#
# newConditions = {"product": "el-server", "build": 0, "branch": "latest"}
# params = json.dumps(newConditions).encode('utf8')
# req = urllib.request.Request("https://update.sineware.ca/get-updates", data=params,
#                              headers={'content-type': 'application/json'})
# response = urllib.request.urlopen(req)
# responseStr = response.read().decode('utf8')
# #print(responseStr)
# sineware_update = json.loads(responseStr)
# if not sineware_update["update_available"]:
#     print("Exiting... (The update server told us that there is nothing available)")
#     exit(-2)
# print("Done.")
#
# print("Going to install Sineware " + sineware_update["update"]["ver_str"])
#
# print("Downloading Root FS files...", end='', flush=True)
# os.system('wget ' + sineware_update["update"]["rootfs_url"] + " -O /tmp/sineware.tar.bz2")
# print("Done.") """

proceed = input("All data on " + install_disk + " will be destroyed. Is this OK? (type yes to continue): ")
if proceed != "yes":
    print("Exiting... (No changes have been made)")
    exit(-1)

print("Partitioning the target drive...")
# Generic x86-64 Disk Configuration (MBR for BIOS and UEFI)
# (128M Boot partition, 1G Root, rest Data partition)
disk_config = """
label: dos
label-id: 0xdfefdc32
unit: sectors

start=     2048, size=  262144, type= ef, bootable
start=   264192, size= 2097152, type= 83
start=  2361344,                type= 83
"""
p = Popen(['sfdisk', install_disk], stdout=PIPE, stdin=PIPE, stderr=STDOUT)
stdout_data = p.communicate(input=disk_config.encode())[0].decode()
print(stdout_data)
if p.poll() != 0:
    print("Exiting... (Failed to format drive)")
    exit(-3)
print ("Installing Sineware...")
print("    -> Formatting drive...")
os.system("mkfs.vfat " + install_disk + "1")
os.system("mkfs.ext4 " + install_disk + "2")
os.system("mkfs.ext4 " + install_disk + "3")

print("    -> Mounting drive...")
os.system("mkdir -pv /mnt/root_a")
os.system("mount " + install_disk + "2 /mnt/root_a")

print("    -> Copying Files...")
os.system("tar -xvf /tmp/sineware.tar.bz2 -C /mnt/root_a")
print("Done copying files.")

print("    ->  Installing GRUB...")

print("    -> Cleaning up...")
os.system("umount " + install_disk + "2")