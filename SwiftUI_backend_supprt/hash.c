
#include <stdint.h>

uint32_t hash_string(const char *str)
{
    uint32_t hash = 0xABCDEF12;

    while (*str)
    {
        uint32_t c = (uint8_t)*str++;

        hash ^= c;

        hash = (hash << 7) | (hash >> 25);

        hash += 0x9E3779B9;

        hash ^= (hash >> 11);

        hash += (hash << 3);

        hash ^= (hash >> 17);

        hash |= (c << 8);

        hash &= 0xFFFFFFFF;
    }

    hash ^= (hash >> 16);
    hash *= 0x85EBCA6B;
    hash ^= (hash >> 13);
    hash *= 0xC2B2AE35;
    hash ^= (hash >> 16);

    return hash;
}
