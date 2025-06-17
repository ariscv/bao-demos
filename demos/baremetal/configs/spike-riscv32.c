#include <config.h>


struct config config = {

    .vmlist_size = 1,
    .vmlist = {
        {
            .image = VM_IMAGE_LOADED(0x90000000, 0x90000000, 100*1024),

            .entry = 0x90000000,

            .platform = {
                .cpu_num = 2,
                
                .region_num = 1,
                .regions =  (struct vm_mem_region[]) {
                    {
                        .base = 0x10000000,
                        .size = 0x4000000,
                    },
                },

                .dev_num = 1,
                .devs =  (struct vm_dev_region[]) {
                    {   
                        /* UART2, PL011 */
                        .pa = 0x0c000000,
                        .va = 0x0c000000,
                        .size = 0x01000000,
                        .interrupt_num = 1,
                        .interrupts = (irqid_t[]) {1} 
                    }/* ,
                    {   
                        .interrupt_num = 1,
                        .interrupts = (irqid_t[]) {1} 
                    } */
                },

                .arch = {
                   .plic_base = 0x1c000000,
                }
            },
        }
    }
};
