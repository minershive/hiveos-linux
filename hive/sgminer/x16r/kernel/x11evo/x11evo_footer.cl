
	bool result = (hash.h8[3] <= target);
	if (result)
		output[output[0xFF]++] = SWAP4(gid);
}

#endif // X11EVO_CL
