# Disk Read & Write

## Disk
----

- Sector：Sector is the basic unit of data storage on a hard disk, the data size is always a power of 2, and is almost always either 512 of 4096 bytes. It can have at most 256 sectors.
- The major block of the harddisk performance is the seeking time of actuator 
- Usually a track is divided to 63 sectors, due to the maximum number BIOs can support  
- Track count from the edge, so the read/write speed of C disk is the fastest.

## IDE / ATA PIO Mode

PIO: Programmed Input Output 

Port is the ；

- IDE：Integrated Drive Electronics 
- ATA：Advanced Technology Attachment  / American National Standards Institute ANSI 
- SATA / PATA

## Disk Read/Write

- CHS mode / Cylinder / Head / Sector
- LBA mode / Logical Block Address

LBA28，can access 128 Gb disk space；

Disk Control Port

| Primary passage            | Secondary passage | in operation      | out operation     |
| ----------------------- | -------------- | ------------ | ------------ |
| 0x1F0                   | 0x170          | Data         | Data         |
| 0x1F1                   | 0x171          | Error        | Features     |
| 0x1F2                   | 0x172          | Sector count | Sector count |
| 0x1F3                   | 0x173          | LBA low      | LBA low      |
| 0x1F4                   | 0x174          | LBA mid      | LBA mid      |
| 0x1F5                   | 0x175          | LBA high     | LBA high     |
| 0x1F6                   | 0x176          | Device       | Device       |
| 0x1F7                   | 0x177          | Status       | Command      |

- 0x1F0：16bit port，Read/Write Data
- 0x1F1：Detect error from last operation
- 0x1F2：the number for the r/w sectors
- 0x1F3： start sector 0 ~ 7 
- 0x1F4： start sector 8 ~ 15
- 0x1F5： start sector 16 ~ 23 
- 0x1F6:
    - 0 ~ 3：start sector 24 ~ 27 
    - 4: 0 master, 1 slave
    - 6: 0 CHS, 1 LBA
    - 5 ~ 7：filled to 1
- 0x1F7: out
    - 0xEC: identify disk
    - 0x20: read disk
    - 0x30: write disk
- 0x1F7: in / 8bit
    - 0 ERR
    - 3 DRQ data is ready
    - 7 BSY disk is busy

## Referrences

- <https://www.youtube.com/watch?v=oEORcCQ62nQ>
- <https://wiki.osdev.org/ATA_PIO_Mode>
- <https://bochs.sourceforge.io/techspec/PORTS.LST>
- <https://www.techtarget.com/searchstorage/definition/IDE>