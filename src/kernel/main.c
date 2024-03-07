#include <meow/meow.h>

int magic = MEOW_MAGIC;
char message[] = "hello meowOS!!"; //.data
char buf[1024]; //.bss

void kernel_init() {
    char * video = (char *) 0xb8000;
    for(int i = 0; i < sizeof(message); i++) {
        video[i * 2] = message[i];
    }
}