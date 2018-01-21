#!/usr/bin/env Rscript

library(tidyverse)
library(sqldf)

pdf(NULL) # prevent Rplot.pdf files

log <- read_tsv("log.tsv")
# parse_datetime can't handle , as ISO8601 separator
tlog <- log %>%
	mutate(time_start = parse_datetime(stringr::str_replace(time_start, ",", ".")),
	       time_end = parse_datetime(stringr::str_replace(time_end, ",", ".")),
	       duration = as.numeric(time_end - time_start))

freq <- read_tsv("freq.tsv")

powermeter <- read_tsv("powermeter.tsv")
rapl <- read_tsv("rapl.tsv")

# Powermeter readings outside of benchmark execution.
idle_power <- sqldf("select * from powermeter where time not in (select time from powermeter, tlog where time > time_start and time < time_end)") %>% as.tibble()
avg_idle_power <- as.double(idle_power %>% summarize(mean(power)))

# Join powermeter data via time ranges. Ignore the first second as the power
# meter takes a bit of time to react.
power_log <- sqldf("select tlog.*, avg(power) power, avg(package) package, avg(core0) core0, avg(core1) core1, avg(core2) core2
		  from tlog
		  left join powermeter on datetime(powermeter.time, 'unixepoch') > datetime(time_start, 'unixepoch', '+1 second') and powermeter.time < time_end
		  left join rapl on rapl.time > time_start and rapl.time < time_end
		  group by time_start, time_end") %>%
              as.tibble() %>%
              mutate(power_offset = power - avg_idle_power) %>%
              left_join(freq %>% select(cpufid, core0, core1, core2),
                        by = c("cpufid"), suffix = c("", ".freq"))

write.table(power_log, file='power_log.tsv', quote=FALSE, sep='\t', row.names=FALSE)

# Graph to check power meter behavior: does it reset properly between runs?
ggplot() +
	geom_line(aes(x = time, y = power), powermeter) +
	geom_vline(aes(xintercept = time_start), tlog, color = "green") +
	geom_vline(aes(xintercept = time_end), tlog, color = "red")

ggsave("powermeter.png", width = 50, height = 20, units = "cm", limitsize = FALSE)
