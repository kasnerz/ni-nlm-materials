"""
Visualize word vectors (cat, dog, car) in 3D space with cosine similarity annotations.
Output: cosine_similarity_3d.png for inclusion in presentation slides.
"""

import matplotlib

# Try setting an interactive backend
try:
    matplotlib.use("Qt5Agg")
except ImportError:
    try:
        matplotlib.use("TkAgg")
    except ImportError:
        pass

import matplotlib.pyplot as plt
import numpy as np
from matplotlib.patches import FancyArrowPatch
from mpl_toolkits.mplot3d import Axes3D, proj3d

# ── Vectors ──────────────────────────────────────────────────
v_cat = np.array([0.9, 0.4, 0.1])
v_dog = np.array([0.8, 0.5, 0.1])
v_car = np.array([0.1, 0.9, -0.4])

vectors = {"cat": v_cat, "dog": v_dog, "car": v_car}
colors = {"cat": "#2196F3", "dog": "#4CAF50", "car": "#F44336"}  # blue, green, red


# ── Cosine similarity helper ────────────────────────────────
def cosine_sim(a, b):
    return np.dot(a, b) / (np.linalg.norm(a) * np.linalg.norm(b))


def angle_deg(a, b):
    return np.degrees(np.arccos(np.clip(cosine_sim(a, b), -1, 1)))


# ── 3D arrow helper ─────────────────────────────────────────
class Arrow3D(FancyArrowPatch):
    """Draw a proper 3D arrow that respects perspective."""

    def __init__(self, xs, ys, zs, *args, **kwargs):
        super().__init__((0, 0), (0, 0), *args, **kwargs)
        self._verts3d = xs, ys, zs

    def do_3d_projection(self, renderer=None):
        xs, ys, zs = self._verts3d
        xs2d, ys2d, zs2d = proj3d.proj_transform(xs, ys, zs, self.axes.M)
        self.set_positions((xs2d[0], ys2d[0]), (xs2d[1], ys2d[1]))
        return min(zs2d)


# ── Figure setup ─────────────────────────────────────────────
fig = plt.figure(figsize=(9, 7), facecolor="white")
ax = fig.add_subplot(111, projection="3d")

# Draw each vector as a 3D arrow
for name, vec in vectors.items():
    arrow = Arrow3D(
        [0, vec[0]],
        [0, vec[1]],
        [0, vec[2]],
        mutation_scale=18,
        lw=3,
        arrowstyle="-|>",
        color=colors[name],
        zorder=10,
    )
    ax.add_artist(arrow)

    # Label at the tip of the arrow (slightly offset outward)
    offset = vec / np.linalg.norm(vec) * 0.08
    tip = vec + offset
    ax.text(
        tip[0],
        tip[1],
        tip[2],
        f"  {name}",
        fontsize=16,
        fontweight="bold",
        color=colors[name],
        ha="left",
        va="bottom",
    )


# ── Draw arc between cat–dog (small angle) ──────────────────
def draw_angle_arc(ax, v1, v2, color, label, radius=0.35, n_points=40):
    """Draw an arc between two vectors and annotate with angle/sim."""
    # Normalize
    u1 = v1 / np.linalg.norm(v1)
    u2 = v2 / np.linalg.norm(v2)

    # Interpolate along the great circle
    theta = np.arccos(np.clip(np.dot(u1, u2), -1, 1))
    ts = np.linspace(0, 1, n_points)
    points = np.array(
        [
            (np.sin((1 - t) * theta) * u1 + np.sin(t * theta) * u2) / np.sin(theta)
            for t in ts
        ]
    )
    points *= radius

    ax.plot(
        points[:, 0],
        points[:, 1],
        points[:, 2],
        color=color,
        lw=2,
        ls="--",
        alpha=0.85,
    )

    # Place label at midpoint of arc
    mid = points[n_points // 2]
    label_offset = mid / np.linalg.norm(mid) * 0.12
    label_pos = mid + label_offset
    ax.text(
        label_pos[0],
        label_pos[1],
        label_pos[2],
        label,
        fontsize=12,
        color=color,
        ha="center",
        va="center",
        bbox=dict(
            boxstyle="round,pad=0.3",
            facecolor="white",
            edgecolor=color,
            alpha=0.9,
        ),
    )


sim_cd = cosine_sim(v_cat, v_dog)
ang_cd = angle_deg(v_cat, v_dog)
sim_cc = cosine_sim(v_cat, v_car)
ang_cc = angle_deg(v_cat, v_car)

draw_angle_arc(
    ax,
    v_cat,
    v_dog,
    color="#555555",
    label=f"θ = {ang_cd:.1f}°\nsim = {sim_cd:.2f}",
    radius=0.40,
)
draw_angle_arc(
    ax,
    v_cat,
    v_car,
    color="#999999",
    label=f"θ = {ang_cc:.1f}°\nsim = {sim_cc:.2f}",
    radius=0.55,
)

# ── Axis styling ─────────────────────────────────────────────
ax.set_xlim([-0.2, 1.1])
ax.set_ylim([-0.2, 1.1])
ax.set_zlim([-0.5, 0.5])

ax.set_xlabel("Dim 1", fontsize=12, labelpad=8)
ax.set_ylabel("Dim 2", fontsize=12, labelpad=8)
ax.set_zlabel("Dim 3", fontsize=12, labelpad=8)

# ax.set_title(
#     "Word Vectors & Cosine Similarity",
#     fontsize=18,
#     fontweight="bold",
#     pad=15,
# )

# Draw origin point
ax.scatter([0], [0], [0], color="black", s=30, zorder=5)

# Set a nice viewing angle
ax.view_init(elev=22, azim=-55)

# Lighten the grid
ax.xaxis.pane.fill = False
ax.yaxis.pane.fill = False
ax.zaxis.pane.fill = False
ax.xaxis.pane.set_edgecolor("lightgrey")
ax.yaxis.pane.set_edgecolor("lightgrey")
ax.zaxis.pane.set_edgecolor("lightgrey")
ax.grid(True, alpha=0.3)

plt.tight_layout()

# ── Save ─────────────────────────────────────────────────────
out_path = "cosine_similarity_3d.png"
fig.savefig(out_path, dpi=200, bbox_inches="tight", facecolor="white")
print(f"Saved to {out_path}")
print(f"\ncat–dog:  sim = {sim_cd:.4f},  angle = {ang_cd:.1f}°")
print(f"cat–car:  sim = {sim_cc:.4f},  angle = {ang_cc:.1f}°")

try:
    plt.show()
except (UserWarning, Exception) as e:
    print(
        f"\nNote: Interactive plot could not be shown ({e}).\n"
        f"Please check the saved image: {out_path}"
    )
