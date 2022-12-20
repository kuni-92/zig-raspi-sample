SECTIONS {
	.text.boot 0x80000 : {
		*(.text.boot)
	}

	.text : {
		*(.text)
	}

	/DISCARD/ : {
		*(.ARM.*)
		*(.debug_*)
		*(.comment)
	}
}
