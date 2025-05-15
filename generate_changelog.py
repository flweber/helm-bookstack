#!/usr/bin/env python3
"""
generate_changelog.py  -  Wandelt den Artifact Hub-Changelog in Chart.yaml
                           in eine Markdown-Datei (CHANGELOG.md) um.

Aufruf:
    python generate_changelog.py            # takes ./Chart.yaml
    python generate_changelog.py path/to/Chart.yaml
"""

import argparse
import datetime as dt
import pathlib
import sys
import textwrap
import yaml


MD_HEADER = "# Changelog\n\n"


def read_chart(path: pathlib.Path) -> dict:
    if not path.exists():
        sys.exit(f"❌ Chart.yaml not found: {path}")
    with path.open() as f:
        return yaml.safe_load(f)


def extract_changes(chart: dict) -> list[dict]:
    try:
        raw = chart["annotations"]["artifacthub.io/changes"]
    except KeyError:
        sys.exit("❌ No 'artifacthub.io/changes' annotations found.")

    try:
        return yaml.safe_load(raw) or []
    except yaml.YAMLError as e:
        sys.exit(f"❌ Changelog annotations are not in a valid YAML format:\n{e}")


def render_markdown(chart: dict, changes: list[dict]) -> str:
    version = chart.get("version", "Unversioniert")
    today = dt.date.today().isoformat()

    heading = f"## {version} - {today}\n"
    bullets = []

    for item in changes:
        kind = item.get("kind", "").capitalize()
        desc = item.get("description", "").strip()
        links = item.get("links", [])
        link_md = ""
        if links:
            link_md = " " + " ".join(f"[{l['name']}]({l['url']})" for l in links)
        bullets.append(f"- **{kind}** {desc}{link_md}")

    return MD_HEADER + heading + "\n".join(bullets) + "\n"


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Generates CHANGELOG.md from Chart.yaml annotations."
    )
    parser.add_argument(
        "chart_yaml",
        nargs="?",
        default="Chart.yaml",
        help="Pfad zur Chart.yaml (Standard: ./Chart.yaml)",
    )
    args = parser.parse_args()

    chart_path = pathlib.Path(args.chart_yaml)
    chart = read_chart(chart_path)
    changes = extract_changes(chart)
    changelog_md = render_markdown(chart, changes)

    outfile = chart_path.parent / "CHANGELOG.md"
    outfile.write_text(changelog_md, encoding="utf-8")
    print(f"✅ CHANGELOG.md generated under {outfile.resolve()}.")


if __name__ == "__main__":
    main()
