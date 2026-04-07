# Cron & Scheduler

## Description

Sets up and manages scheduled tasks using cron, systemd timers, and modern alternatives (systemd timers, schedule Python library, Celery Beat, cron in containers). Handles scheduling, error handling, alerting, and maintenance.

## Triggered When

- User says "set up cron job", "schedule this task", "run this daily"
- User says "đặt lịch cron", "lên lịch chạy task", "chạy mỗi ngày", "schedule"
- User asks "cron expression", "systemd timer", "celery beat setup"
- User says "cron expression", "cron job", "celery beat", "automate task"
- User wants to schedule a Python script to run periodically
- User says "run every 5 minutes", "daily at 2am", "every Monday"

## Workflow

### 1. Assess the Task
- Frequency: once, hourly, daily, weekly, custom cron
- Duration: seconds, minutes, or hours
- Environment: local server, container, cloud
- Persistence needed: survive reboot? (cron=yes, manual run=no)

### 2. Choose Scheduling Tool

| Use case | Tool |
|---|---|
| Simple local task | cron (crontab) |
| Needs to survive reboot, fine-grained | systemd timer |
| Python script in same process | schedule library |
| Distributed / production queue | Celery Beat, RQ, Airflow |
| Cloud function | AWS EventBridge, GCP Cloud Scheduler |

### 3. Write the Cron Expression
```
# ┌───────────── minute (0-59)
# │ ┌───────────── hour (0-23)
# │ │ ┌───────────── day of month (1-31)
# │ │ │ ┌───────────── month (1-12)
# │ │ │ │ ┌───────────── day of week (0-6, Sun=0)
# │ │ │ │ │
# * * * * * command
```

Common patterns:
- Every 5 min: `*/5 * * * *`
- Daily at 2:30am: `30 2 * * *`
- Weekdays at 9am: `0 9 * * 1-5`
- First of month: `0 0 1 * *`
- Every Sunday at midnight: `0 0 * * 0`

### 4. Robust Scripting
- Use absolute paths (cron's $PATH is minimal)
- Redirect output to log file: `>> /var/log/my-task.log 2>&1`
- Exit with meaningful codes (0=success, non-zero=error)
- Add locking to prevent overlap (flock, or pid file)

### 5. Monitoring & Alerting
- Log to file or syslog
- Send alert on failure (email, Slack webhook, PagerDuty)
- Monitor cron itself: missing runs = alert

### 6. systemd Timer (Linux)

```ini
# /etc/systemd/system/my-task.service
[Service]
Type=oneshot
ExecStart=/usr/bin/python3 /opt/my-task.py
WorkingDirectory=/opt

# /etc/systemd/system/my-task.timer
[Timer]
OnCalendar=daily
Persistent=true
```

## Output Format

```
## ⏰ Scheduled Task — [task name]

### Schedule
- Cron expression: [expression]
- Human readable: [description]
- Next run: [datetime]
- Tool: [cron/systemd/schedule/Celery Beat]

### Task Details
- Command: [command or script path]
- Timeout: [duration]
- Retry on failure: [yes/no — method]
- Overlap protection: [yes/no — method]

### Monitoring
- Log location: [path]
- Alert on failure: [yes/no — method]
- Alert on missing run: [yes/no]

### Setup Commands
[shell commands to set up the cron job]
```

## Rules

- Always use absolute paths in cron — never assume $PATH
- Add overlap protection for long-running tasks (prevent double-run)
- Log everything to file, not just stdout
- Test the script standalone before adding to cron
- Use `@reboot` sparingly — systemd timer is better for reboot-resilient tasks
