#include <iostream>
#include <string>
#include <sys/ipc.h>
#include <sys/shm.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>

#include "libsshm.hpp"

struct SimpleChannel openChannel (const std::string channelName, const size_t channelSize) {
	key_t key;
	int shmid, shmGetFlags, shmAttachFlags;
	void * shm;
	std::string fileName = "/dev/shm/" + channelName;

	// First, check if a non-zero size was given
	if (channelSize <= 0) {
		std::cerr << "SimpleChannel size should be stictly positive." << std::endl;
		exit(1);
	}

	// Check if a file with the channel name exists, create it if not
	if (!fileExist(fileName)) {
		fclose(fopen(fileName.c_str(), "w"));
	}

	// Create the key associated with the SHM segment
	if ((key = ftok(fileName.c_str(), 1089)) == -1) {
		perror("Failed to create key from file");
		exit(1);
	}

	// Populate flags
	shmGetFlags = IPC_CREAT | 0644;
	shmAttachFlags = 0;

	// Create the shm segment
	if ((shmid = shmget(key, channelSize, shmGetFlags)) == -1) {
		perror("Failed to create the SHM segment");
		exit(1);
	}

	// Attach to SHM segment to get back pointer to it
	shm = shmat(shmid, NULL, shmAttachFlags);
	if (shm == (void *) -1) {
		perror("Failed to attach to the SHM segment");
		exit(1);
	}

	// Return the SimpleChannel object
	struct SimpleChannel sChannel;
	sChannel.shm = shm;

	return sChannel;
}

void closeChannel (struct SimpleChannel channel) {
	if (shmdt(channel.shm) == -1) {
		perror("Failed to detach from the SHM segment");
		// Not exiting here, because this function will probably be called in cleaning routine
	}
}

inline bool fileExist (const std::string& filename) {
	struct stat buffer;
	return(stat(filename.c_str(), &buffer) == 0);
}
