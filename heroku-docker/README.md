# Heroku-Docker OVA

[Jidoteki](https://jidoteki.com) is a platform for automatically building virtual appliances.

We use it exclusively as part of our **managed service**, helping SaaS companies package their stack & application in order to sell it to **enterprise** customers.

  1. [Usage](#usage)
  2. [Build details](#build-details)
  3. [Installation ISO](#installation-iso)
  4. [Boot command](#boot-command)
  5. [Installation script](#installation-script)
  6. [Installation screenshots](#installation-screenshots)

The OVA is simply a `.tar` file which includes an `.ovf`, a 75GB sparse vmdk disk, and the `boot2docker v1.6.0` ISO.

  * SHA256 hash: `e5310eba4e92d1f5e861a4cf06818d1afa4b181b05ce79796a0bcf85671d71cd`
  * File size: `494.9MiB`

## Usage

  1. Download the [ISO from S3](https://s3-ap-northeast-1.amazonaws.com/jidoteki/public/appliances/heroku-docker-1.6.0.ova)
  2. Import the .ova into `VirtualBox` or `VMware`
  3. Modify the RAM and CPU settings
  4. Setup SSH port forwarding (to local port 22)
  5. ..
  6. Profit?

## Build details

In this section we explain exactly how we built the appliance.

## Installation ISO

The install ISO we used is the [official boot2docker](https://github.com/boot2docker/boot2docker/releases) ISO downloaded directly from GitHub.

```
URL: https://github.com/boot2docker/boot2docker/releases/download/v1.6.0/boot2docker.iso
SHA256 hash: b7a33c5f96d6e82107cfd00164dbb01656fb9c5b04d8a20efb744d05fc838f9e
File size: 23 MiB
```

## Boot command

Jidoteki uses boot commands similar to `Veewee` and `Packer`.

```
<wait10><wait10><wait10><wait10><wait10>
mkfs.ext4 -L boot2docker-data -F /dev/sda<enter>
<wait5>
reboot<enter>
<wait5>
<wait10><wait10><wait10><wait10><wait10>
curl http://<ip>:<port>/setup.cfg | /bin/sh<enter>
```

## Installation script

We wrote a quick installation script which simply pulls the `heroku/cedar` Docker image:

```
#!/bin/sh

/usr/local/etc/init.d/openssh stop
docker pull heroku/cedar:14
sync
/usr/local/etc/init.d/openssh start
```

## Installation screenshots

![screenshot-1](https://cloud.githubusercontent.com/assets/153401/7514276/9b7af284-f4ab-11e4-9cf4-d5e74959fab3.png)
![screenshot-2](https://cloud.githubusercontent.com/assets/153401/7514279/9b7f66ac-f4ab-11e4-801b-5f8997ff003e.png)
![screenshot-3](https://cloud.githubusercontent.com/assets/153401/7514277/9b7e8570-f4ab-11e4-8786-f53393bf5b1a.png)
![screenshot-4](https://cloud.githubusercontent.com/assets/153401/7514280/9b7fa36a-f4ab-11e4-891c-f0664a55af8b.png)
![screenshot-5](https://cloud.githubusercontent.com/assets/153401/7514278/9b7f22be-f4ab-11e4-8fe9-745cc30a5680.png)
