"""Generate a timeline chart of LLM model sizes (2017–2021)."""

from datetime import datetime
from pathlib import Path

import matplotlib.dates as mdates
import matplotlib.pyplot as plt
import numpy as np
from matplotlib.ticker import FuncFormatter
from scipy.optimize import curve_fit

# ── Data ────────────────────────────────────────────────────────────────────
models = [
    ("2017-06-01", "Transformer", 0.05, "Google"),
    ("2018-03-01", "GPT", 0.11, "OpenAI"),
    ("2018-06-01", "BERT", 0.11, "Google"),
    ("2019-02-01", "GPT-2", 1.5, "OpenAI"),
    ("2019-10-01", "T-NLG", 17.0, "Microsoft"),
    ("2020-06-01", "GPT-3", 175.0, "OpenAI"),
    ("2021-01-01", "Switch Transformer", 1600.0, "Google"),
]

dates = [datetime.strptime(d, "%Y-%m-%d") for d, *_ in models]
names = [m[1] for m in models]
sizes = np.array([m[2] for m in models])
companies = [m[3] for m in models]

# ── Style ───────────────────────────────────────────────────────────────────
plt.rcParams.update(
    {
        "font.family": "sans-serif",
        "font.sans-serif": ["Fira Sans", "DejaVu Sans", "Helvetica", "Arial"],
        "font.size": 19,
        "axes.linewidth": 1.1,
        "axes.edgecolor": "#333333",
        "axes.labelcolor": "#222222",
        "xtick.color": "#444444",
        "ytick.color": "#444444",
        "figure.facecolor": "white",
        "axes.facecolor": "white",
        "axes.grid": True,
        "grid.alpha": 0.18,
        "grid.linewidth": 0.7,
        "grid.color": "#b5b5b5",
    }
)

fig, ax = plt.subplots(figsize=(8.5, 4.8))

# ── Exponential fit ─────────────────────────────────────────────────────────
date_nums = mdates.date2num(dates)


def exp_func(x, a, b):
    return a * np.exp(b * (x - date_nums[0]))


popt, _ = curve_fit(exp_func, date_nums, sizes, p0=[0.01, 0.01], maxfev=10000)

# Fit curve (dotted, through data range)
fit_x = np.linspace(date_nums[0] - 20, date_nums[-1], 400)
fit_y = exp_func(fit_x, *popt)
ax.plot(
    mdates.num2date(fit_x),
    fit_y,
    linestyle=":",
    color="#aaaaaa",
    linewidth=2.0,
    zorder=1,
)

# Projection beyond last point (dotted) + arrowhead
proj_end_x = date_nums[-1] + 150
proj_x = np.linspace(date_nums[-1], proj_end_x, 100)
proj_y = exp_func(proj_x, *popt)
mask = proj_y <= sizes.max() * 1.35
proj_x, proj_y = proj_x[mask], proj_y[mask]

# Draw dotted projection line
ax.plot(
    mdates.num2date(proj_x),
    proj_y,
    linestyle=":",
    color="#aaaaaa",
    linewidth=2.0,
    zorder=1,
)

# Arrowhead at the tip (use a short solid annotation just for the head)
ax.annotate(
    "",
    xy=(mdates.num2date(proj_x[-1]), proj_y[-1]),
    xytext=(mdates.num2date(proj_x[-6]), proj_y[-6]),
    arrowprops=dict(
        arrowstyle="-|>",
        color="#aaaaaa",
        lw=2.0,
        mutation_scale=18,
    ),
    zorder=2,
)

# ── Data points (small circles) ────────────────────────────────────────────
DOT_COLOR = "#2b2b2b"
ax.scatter(dates, sizes, s=90, color=DOT_COLOR, zorder=10, clip_on=False)

# ── Labels ──────────────────────────────────────────────────────────────────
# Name offsets in points. Parameter counts are placed below the name in grey.
label_config: dict[str, dict] = {
    "Transformer": {"dx": 0, "dy": 40, "ha": "center", "va": "bottom"},
    "GPT": {"dx": -8, "dy": 40, "ha": "center", "va": "bottom"},
    "BERT": {"dx": 8, "dy": 40, "ha": "center", "va": "bottom"},
    "GPT-2": {"dx": 0, "dy": 40, "ha": "center", "va": "bottom"},
    "T-NLG": {"dx": 0, "dy": 40, "ha": "center", "va": "bottom"},
    "GPT-3": {"dx": 0, "dy": 40, "ha": "center", "va": "bottom"},
    "Switch Transformer": {"dx": 0, "dy": -30, "ha": "center", "va": "top"},
}


def fmt_size(s: float) -> str:
    if s >= 1000:
        return f"{s/1000:.1f}T"
    if s >= 1:
        return f"{s:.0f}B" if s == int(s) else f"{s:.1f}B"
    return f"{s:.2f}B"


for date, name, size, company in zip(dates, names, sizes, companies):
    cfg = label_config.get(name, {"dx": 0, "dy": 40, "ha": "center", "va": "bottom"})
    dx, dy, ha, va = cfg["dx"], cfg["dy"], cfg["ha"], cfg["va"]

    # Model name
    ax.annotate(
        name,
        xy=(date, size),
        xytext=(dx, dy),
        textcoords="offset points",
        fontsize=18,
        fontweight="semibold",
        color="#222222",
        ha=ha,
        va=va,
        zorder=9,
    )

    # Parameter count below the name
    count_dy = dy - 18 if va == "bottom" else dy + 18
    ax.annotate(
        fmt_size(size),
        xy=(date, size),
        xytext=(dx, count_dy),
        textcoords="offset points",
        fontsize=15,
        fontweight="medium",
        color="#7a7a7a",
        ha=ha,
        va=va,
        zorder=9,
    )

# ── Axes formatting ────────────────────────────────────────────────────────
ax.set_xlabel("Year", fontsize=19, fontweight="medium", labelpad=8)
ax.set_ylabel("Model size (parameters)", fontsize=19, fontweight="medium", labelpad=8)

ax.xaxis.set_major_locator(mdates.YearLocator())
ax.xaxis.set_major_formatter(mdates.DateFormatter("%Y"))

ax.set_yticks([0, 500, 1000, 1500])
ax.yaxis.set_major_formatter(
    FuncFormatter(lambda v, _: f"{v/1000:.1f}T" if v >= 1000 else f"{v:.0f}B")
)

ax.set_xlim(datetime(2017, 1, 1), datetime(2021, 7, 15))
ax.set_ylim(-40, 1875)

ax.tick_params(axis="both", which="major", length=5, width=0.8, labelsize=17)

# Remove top/right spines
ax.spines["top"].set_visible(False)
ax.spines["right"].set_visible(False)

plt.tight_layout()

OUT = Path(__file__).parent
plt.savefig(
    OUT / "model_sizes.png",
    dpi=200,
    bbox_inches="tight",
    facecolor="white",
    edgecolor="none",
)
plt.savefig(
    OUT / "model_sizes.pdf", bbox_inches="tight", facecolor="white", edgecolor="none"
)
print("Saved model_sizes.png and model_sizes.pdf")
plt.show()
