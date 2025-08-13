import time
import json
import sys


def get_network_stats():
    """读取网络接口统计信息"""
    with open("/proc/net/dev", "r") as f:
        lines = f.readlines()

    total_rx = 0
    total_tx = 0

    for line in lines[2:]:  # 跳过头两行
        if ":" in line:
            parts = line.split(":")
            interface = parts[0].strip()
            # 跳过 lo (本地回环)
            if interface == "lo":
                continue

            stats = parts[1].split()
            rx_bytes = int(stats[0])  # 接收字节
            tx_bytes = int(stats[8])  # 发送字节

            total_rx += rx_bytes
            total_tx += tx_bytes

    return total_rx, total_tx


def main():
    prev_rx, prev_tx = get_network_stats()

    while True:
        time.sleep(1)  # 每秒更新一次
        curr_rx, curr_tx = get_network_stats()

        # 计算速度 (字节/秒)
        rx_speed = curr_rx - prev_rx
        tx_speed = curr_tx - prev_tx

        # 转换为 KB/s
        rx_kb = rx_speed / 1024
        tx_kb = tx_speed / 1024

        # 输出 JSON 格式
        result = {"download": round(rx_kb, 1), "upload": round(tx_kb, 1)}

        print(json.dumps(result))
        sys.stdout.flush()  # 确保立即输出

        prev_rx = curr_rx
        prev_tx = curr_tx


if __name__ == "__main__":
    main()
