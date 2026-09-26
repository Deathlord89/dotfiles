{
  services.udev.extraHwdb = ''
    # This file is to remap the keys on the Razor Tartarus Pro
    evdev:input:b0003v1532p0244*
    # Top row
     KEYBOARD_KEY_7001e=esc
     KEYBOARD_KEY_7001f=1
     KEYBOARD_KEY_70020=2
     KEYBOARD_KEY_70021=3
     KEYBOARD_KEY_70022=4
    # Second row
     KEYBOARD_KEY_7002b=tab
     KEYBOARD_KEY_70014=5
     KEYBOARD_KEY_7001a=6
     KEYBOARD_KEY_70008=7
     KEYBOARD_KEY_70015=8
    # Third row
     KEYBOARD_KEY_70039=leftalt
     KEYBOARD_KEY_70004=9
     KEYBOARD_KEY_70016=0
     KEYBOARD_KEY_70007=minus
     KEYBOARD_KEY_70009=slash
    # Fourth row
     KEYBOARD_KEY_700e1=leftshift
     KEYBOARD_KEY_7001d=semicolon
     KEYBOARD_KEY_7001b=apostrophe
     KEYBOARD_KEY_70006=leftbrace
    # Thumb button above thumbstick
     KEYBOARD_KEY_700e2=rightbrace
    # Thumbstick
     KEYBOARD_KEY_70052=w
     KEYBOARD_KEY_70051=s
     KEYBOARD_KEY_70050=a
     KEYBOARD_KEY_7004f=d
    # Thumb button below thumbstick
     KEYBOARD_KEY_7002c=backslash
  '';
}
