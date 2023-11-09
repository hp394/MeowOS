# Kernal Loader

- Implement Kernal Loader
- write the loader to disk
- Read it in the main guidence sector
- Check correctness
- Jump to load and execute it

## Memory Layout of Read Mode

| Start Address  | End Address  | Size     | Function               |
| --------- | --------- | -------- | ------------------ |
| `0x000`   | `0x3FF`   | 1KB      | Interrupt Vector Table         |
| `0x400`   | `0x4FF`   | 256B     | BIOS data block        |
| `0x500`   | `0x7BFF`  | 29.75 KB | Feasible Region          |
| `0x7C00`  | `0x7DFF`  | 512B     | MBR load region     |
| `0x7E00`  | `0x9FBFF` | 607.6KB  | Feasible Region            |
| `0x9FC00` | `0x9FFFF` | 1KB      | Extend BIOS data region   |
| `0xA0000` | `0xAFFFF` | 64KB     | 用于彩色显示适配器 |
| `0xB0000` | `0xB7FFF` | 32KB     | 用于黑白显示适配器 |
| `0xB8000` | `0xBFFFF` | 32KB     | 用于文本显示适配器 |
| `0xC0000` | `0xC7FFF` | 32KB     | 显示适配器 BIOS    |
| `0xC8000` | `0xEFFFF` | 160KB    | Mapping Memory           |
| `0xF0000` | `0xFFFEF` | 64KB-16B | System BIOS          |
| `0xFFFF0` | `0xFFFFF` | 16B      | System BIOS Entrance Address |