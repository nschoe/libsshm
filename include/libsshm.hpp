#ifndef _LIBSSHM_HPP_
#define _LIBSSHM_HPP_

#include <string>

struct SimpleChannel {
	void * shm;
};

struct SimpleChannel openChannel (const std::string channelName, const size_t channelSize);

void closeChannel (struct SimpleChannel channel);

bool fileExist (const std::string& filename);

#endif
