import sys
from collections import defaultdict

raw_path = sys.argv[1]
out_path = sys.argv[2]

groups = defaultdict(list)

with open(raw_path, encoding="utf-8") as f:
    for line in f:
        line = line.rstrip("\n")
        if not line.strip():
            continue
        parts = line.split("\t")
        if len(parts) < 2:
            continue
        group = parts[0].strip() or "No Area"
        name = parts[1].strip()
        due = parts[2].strip() if len(parts) > 2 else ""
        if not name:
            continue
        groups[group].append((name, due))

lines = []
lines.append("---")
lines.append("tags:")
lines.append("  - things3-export")
lines.append("obsidianUIMode: preview")
lines.append("---")
lines.append("")
lines.append("# Things3 export")
lines.append("")
lines.append("Auto-generated snapshot of open Things3 to-dos. Overwritten each time the export script runs - do not edit by hand.")
lines.append("")

for group in sorted(groups.keys()):
    lines.append(f"## {group}")
    lines.append("")
    for name, due in groups[group]:
        suffix = f" 📅 {due}" if due else ""
        lines.append(f"- [ ] {name}{suffix}")
    lines.append("")

with open(out_path, "w", encoding="utf-8") as f:
    f.write("\n".join(lines))

print(f"Wrote {sum(len(v) for v in groups.values())} to-dos across {len(groups)} groups to {out_path}")
