#*******************************************************************#
#			      logger.sh				    #
#			    Version: 0.1.0			    #
#			written by xueshumeng			    #
#			xue.shumeng@yahoo.com			    #
#		     Tue Dec 04 15:24:35 CST 2018		    #
#			Shell Script 日志工具			    #
#*******************************************************************#


LOFF=-1;LTRACE=0;LDEBUG=1;LINFO=2;LWARN=3;LERROR=4;LFATAL=5

TRACE_FORMAT="[%s] [TRACE]\n%s\n"
DEBUG_FORMAT="[%s] [DEBUG]\n%s\n"
INFO_FORMAT="[%s] [INFO]\n%s\n"
WARN_FORMAT="[%s] [WARN]\n%s\n"
ERROR_FORMAT="[%s] [ERROR]\n%s\n"
FATAL_FORMAT="[%s] [FATAL]\n%s\n"

if [[ -z "$APPENDERS" ]]; then
    APPENDERS=TERMINAL
fi

DEFAULT_LOGGER_LEVEL=LINFO

#*******************************************************************#
#                          TRACE 在线调试。			    #
#       该级别日志，默认情况下，既不打印到终端也不输出到文件。	    #
#                 此时，对程序运行效率几乎不产生影响		    #
#*******************************************************************#

function logger_trace {
    init_logger_level
    if [[ $LEVEL -le $LTRACE ]]; then
	if [[ "$APPENDERS" =~ "TERMINAL" ]]; then
	    printf "$TRACE_FORMAT" "`date`" "$1" >&2
	fi
	if [[ "$APPENDERS" =~ "FILE" ]]; then
	    if [[ -f "$LOGGER_FILE_FULL_NAME" ]]; then
		printf "$TRACE_FORMAT" "`date`" "$1" >> $LOGGER_FILE_FULL_NAME
	    fi
	fi
    fi
}

#*******************************************************************#
#                     DEBUG 终端查看、在线调试。		    #
#  该级别日志，默认情况下会打印到终端输出，但是不会归档到日志文件。  #
#    因此，一般用于开发者在程序当前启动窗口上，查看日志流水信息。    #
#*******************************************************************#

function logger_debug {
    init_logger_level
    if [[ $LEVEL -le $LDEBUG ]]; then
	if [[ "$APPENDERS" =~ "TERMINAL" ]]; then
	    printf "$DEBUG_FORMAT" "`date`" "$1" >&2
	fi
	if [[ "$APPENDERS" =~ "FILE" ]]; then
	    if [[ -f "$LOGGER_FILE_FULL_NAME" ]]; then
		printf "$DEBUG_FORMAT" "`date`" "$1" >> $LOGGER_FILE_FULL_NAME
	    fi
	fi
    fi
}

#*******************************************************************#
#		    INFO 报告程序进度和状态信息。		    #
#	     一般这种信息都是一过性的，不会大量反复输出。	    #
#*******************************************************************#

function logger_info {
    init_logger_level
    if [[ $LEVEL -le $LINFO ]]; then
	if [[ "$APPENDERS" =~ "TERMINAL" ]]; then
	    printf "$INFO_FORMAT" "`date`" "$1" >&2
	fi
	if [[ "$APPENDERS" =~ "FILE" ]]; then
	    if [[ -f "$LOGGER_FILE_FULL_NAME" ]]; then
		printf "$INFO_FORMAT" "`date`" "$1" >> $LOGGER_FILE_FULL_NAME
	    fi
	fi
    fi
}

#*******************************************************************#
#			   WARNING 警告信息			    #
#	      程序处理中遇到非法数据或者某种可能的错误。	    #
#	  该错误是一过性的、可恢复的，不会影响程序继续运行，	    #
#			 程序仍处在正常状态。			    #
#*******************************************************************#

function logger_warn {
    init_logger_level
    if [[ $LEVEL -le $LWARN ]]; then
	if [[ "$APPENDERS" =~ "TERMINAL" ]]; then
	    printf "$WARN_FORMAT" "`date`" "$1" >&2
	fi
	if [[ "$APPENDERS" =~ "FILE" ]]; then
	    if [[ -f "$LOGGER_FILE_FULL_NAME" ]]; then
		printf "$WARN_FORMAT" "`date`" "$1" >> $LOGGER_FILE_FULL_NAME
	    fi
	fi
    fi
}

#*******************************************************************#
#			    ERROR 状态错误			    #
#	    该错误发生后程序仍然可以运行，但是极有可能运行	    #
#	  在某种非正常的状态下，导致无法完成全部既定的功能。	    #
#*******************************************************************#

function logger_error {
    init_logger_level
    if [[ $LEVEL -le $LERROR ]]; then
	if [[ "$APPENDERS" =~ "TERMINAL" ]]; then
	    printf "$ERROR_FORMAT" "`date`" "$1" >&2
	fi
	if [[ "$APPENDERS" =~ "FILE" ]]; then
	    if [[ -f "$LOGGER_FILE_FULL_NAME" ]]; then
		printf "$ERROR_FORMAT" "`date`" "$1" >> $LOGGER_FILE_FULL_NAME
	    fi
	fi
    fi
}

#*******************************************************************#
#			   FATAL 致命的错误			    #
#	     表明程序遇到了致命的错误，必须马上终止运行。	    #
#*******************************************************************#

function logger_fatal {
    init_logger_level
    if [[ $LEVEL -le $LFATAL ]]; then
	if [[ "$APPENDERS" =~ "TERMINAL" ]]; then
	    printf "$FATAL_FORMAT" "`date`" "$1" >&2
	fi
	if [[ "$APPENDERS" =~ "FILE" ]]; then
	    if [[ -f "$LOGGER_FILE_FULL_NAME" ]]; then
		printf "$FATAL_FORMAT" "`date`" "$1" >> $LOGGER_FILE_FULL_NAME
	    fi
	fi
    fi
}

function init_logger_level {
    if [[ -n "$LOGGER_LEVEL" ]]; then
	eval LEVEL=\$$LOGGER_LEVEL
    else
	eval LEVEL=\$$DEFAULT_LOGGER_LEVEL
    fi
}

function init_logger {

    if [[ "$APPENDERS" =~ "FILE" ]]; then
	if [[ ! -f "$LOGGER_DIRECTORY/$LOGGER_FILE_NAME" ]]; then

	    if [[ -z "$LOGGER_DIRECTORY" ]]; then
		LOGGER_DIRECTORY="`pwd`/logs"
	    fi

	    if [[ ! -d "$LOGGER_DIRECTORY" ]]; then
		mkdir -p "$LOGGER_DIRECTORY"
	    fi

	    if [[ -z "$LOGGER_FILE_NAME" ]]; then
		LOGGER_FILE_NAME="`date '+%Y%m%d%H%M%S'`.log"
	    fi
	    LOGGER_FILE_FULL_NAME="$LOGGER_DIRECTORY/$LOGGER_FILE_NAME"
	    touch "$LOGGER_FILE_FULL_NAME"
	fi
    fi

}

init_logger
