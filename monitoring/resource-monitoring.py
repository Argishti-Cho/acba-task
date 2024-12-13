import psutil
import requests
import time
import logging

# Slack webhook URL
# update with your slack webhook link secrets
SLACK_WEBHOOK_URL = "https://hooks.slack.com/services/secret1/secret2"

# Log file configuration
LOG_FILE = "/var/log/monitor_system.log"
logging.basicConfig(
    filename=LOG_FILE,
    level=logging.INFO,
    format="%(asctime)s - %(levelname)s - %(message)s"
)

def send_slack_notification(message):
    """
    Sends a message to Slack via a webhook.
    """
    payload = {"text": message}
    try:
        response = requests.post(SLACK_WEBHOOK_URL, json=payload, timeout=10)
        if response.status_code == 200:
            logging.info(f"Notification sent: {message}")
        else:
            logging.error(
                f"Failed to send Slack message. Status code: {response.status_code}, Response: {response.text}"
            )
    except requests.exceptions.RequestException as e:
        logging.error(f"Error sending notification: {e}")

def monitor_resources():
    """
    Monitors CPU, memory, and disk usage.
    Sends a Slack notification if usage exceeds 20%.
    Logs activity to a file.
    """
    logging.info("Starting system resource monitoring.")
    while True:
        try:
            # Resource usage
            cpu_usage = psutil.cpu_percent(interval=1)
            memory_usage = psutil.virtual_memory().percent
            disk_usage = psutil.disk_usage('/').percent

            alert_messages = []

            if cpu_usage > 20:
                alert_messages.append(f"CPU usage: {cpu_usage}%")
            if memory_usage > 20:
                alert_messages.append(f"Memory usage: {memory_usage}%")
            if disk_usage > 20:
                alert_messages.append(f"Disk usage: {disk_usage}%")

            # Send notification if any threshold is exceeded
            if alert_messages:
                full_alert_message = "High resource usage detected:\n" + "\n".join(alert_messages)
                send_slack_notification(full_alert_message)
                logging.warning(full_alert_message)
            else:
                logging.info("Resource usage is normal.")

            time.sleep(60)  # checks every 1 minute
        except Exception as e:
            logging.error(f"Unexpected error in resource monitoring: {e}")
            time.sleep(60)

if __name__ == "__main__":
    try:
        monitor_resources()
    except KeyboardInterrupt:
        logging.info("Monitoring stopped by user.")
    except Exception as e:
        logging.critical(f"Critical error: {e}")
