SPARK_CHARS = "▁▂▃▄▅▆▇█"

def sparkline(values):
    """
    Turn a list of numeric values 1-10 into a unicode sparkline.
    """
    if not values:
        return ""
    step = (max(values) - min(values) or 1) / (len(SPARK_CHARS) - 1)
    scaled = [int((v - min(values)) / step) for v in values]
    return "".join(SPARK_CHARS[i] for i in scaled)