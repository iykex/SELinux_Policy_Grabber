# SELinux_Policy_Grabber
Этот простой скрипт предназначен для решения проблем с SELinux для деревьев устройств. 

Использование:
- Поместить скрипт в **корневую директорию пользователя**
- Поместить рядом со скриптом **log.txt** (лог файл) формата:
> I auditd  : type=1400 audit(0.0:3): avc: denied { create } for comm="init" name="sdcard" scontext=u:r:init:s0 tcontext=u:object_r:tmpfs:s0 tclass=lnk_file permissive=1
I init    : type=1400 audit(0.0:3): avc: denied { create } for name="sdcard" scontext=u:r:init:s0 tcontext=u:object_r:tmpfs:s0 tclass=lnk_file permissive=1
I auditd  : type=1400 audit(0.0:4): avc: denied { mounton } for comm="init" path="/mnt/media_rw" dev="tmpfs" ino=75 scontext=u:r:init:s0 tcontext=u:object_r:mnt_media_rw_file:s0 tclass=dir permissive=1
I init    : type=1400 audit(0.0:4): avc: denied { mounton } for path="/mnt/media_rw" dev="tmpfs" ino=75 scontext=u:r:init:s0 tcontext=u:object_r:mnt_media_rw_file:s0 tclass=dir permissive=1
I auditd  : type=1400 audit(0.0:6): avc: denied { read } for comm="e2fsck" name="mmcblk0p22" dev="tmpfs" ino=1402 scontext=u:r:fsck:s0 tcontext=u:object_r:block_device:s0 tclass=blk_file permissive=1
I e2fsck  : type=1400 audit(0.0:6): avc: denied { read } for name="mmcblk0p22" dev="tmpfs" ino=1402 scontext=u:r:fsck:s0 tcontext=u:object_r:block_device:s0 tclass=blk_file permissive=1
I auditd  : type=1400 audit(0.0:7): avc: denied { open } for comm="e2fsck" path="/dev/block/mmcblk0p22" dev="tmpfs" ino=1402 scontext=u:r:fsck:s0 tcontext=u:object_r:block_device:s0 tclass=blk_file permissive=1
- Выполнить 
```
    bash SELinux_grabber.sh
```

- В директории **~/out/sepolicy** будут файлы с нужными правами исходя из ошибок в логе.
