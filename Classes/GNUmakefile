# ObjectiveZMQ

ifeq ($(GNUSTEP_MAKEFILES),)
 GNUSTEP_MAKEFILES := $(shell gnustep-config --variable=GNUSTEP_MAKEFILES 2>/dev/null)
endif

ifeq ($(GNUSTEP_MAKEFILES),)
  $(error You need to set GNUSTEP_MAKEFILES before compiling!)
endif

include $(GNUSTEP_MAKEFILES)/common.make

GNUSTEP_HOST_OS := $(shell gnustep-config --variable=GNUSTEP_HOST_OS 2>/dev/null)


SUBPROJECT_NAME = ObjectiveZMQ

ADDITIONAL_CPPFLAGS     += -std=c99 -fobjc-arc
ADDITIONAL_OBJC_LIBS    += -ldispatch
ADDITIONAL_CXX_LIBS     += -lstdc++

ObjectiveZMQ_OBJC_FILES +=	\
	NSData+ZMQMessage.m	\
	OZContext.m		\
	OZMessage.m		\
	OZSocket+Private.m	\
	OZSocket+Receive.m	\
	OZSocket+Send.m		\
	OZSocket+Subclass.m	\
	OZSocket.m		\
	OZSocketPub.m		\
	OZSocketRep.m		\
	OZSocketReq.m		\
	OZSocketSub.m		\
	OZSocketPull.m		\
	OZSocketPush.m		\

-include GNUmakefile.preamble
include $(GNUSTEP_MAKEFILES)/subproject.make
-include GNUmakefile.postamble
