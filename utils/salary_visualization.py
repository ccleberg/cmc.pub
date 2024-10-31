"""
A file that will visualize salary data from an incoming CSV.

This script reads a CSV file containing salary data and visualizes it using
plotly.
"""

import locale
from pandas import read_csv as pd_read_csv
import pandas as pd
import plotly.graph_objs as go

locale.setlocale(locale.LC_ALL, 'en_US.UTF-8')

# Read the CSV file
df = pd_read_csv('~/git/cleberg.net/theme/static/salary.csv')

def format_currency(value: float) -> str:
    """
    Format values in USD currency format.

    Args:
        value (float): The value to be formatted.

    Returns:
        str: The formatted value.
    """
    return f"${value:,.2f}"

# Reverse the order of the DataFrame
df = df.iloc[::-1].reset_index(drop=True)

# Calculate the percentage increase
df['Percentage Increase'] = df['Salary'].pct_change() * 100

def create_trace(row: pd.Series) -> go.Scatter:
    """
    Create a scatter plot trace for a single row.

    Args:
        row (pd.Series): The row to be plotted.

    Returns:
        go.Scatter: The created scatter plot trace.
    """
    title_company = f"{row['Title']} ({row['Company']})"
    salary_formatted = format_currency(row['Salary'])
    if pd.notna(row['Percentage Increase']):
        text = f"{salary_formatted} ({row['Percentage Increase']:.2f}%)"
    else:
        text = salary_formatted
    return go.Scatter(
        x=[row['Start'], row['End']],
        y=[row['Salary'], row['Salary']],
        text=[text],
        mode='lines+text',
        name=title_company,
        textposition='top center'
    )

# Initialize the plot
fig = go.Figure()

# Add each data point as a separate trace to display the text
for index, row in df.iterrows():
    fig.add_trace(create_trace(row))

# Update visual styles of the figure
fig.update_layout(
    title="Salary Data Over Time (annualized)",
    xaxis_title="Time",
    yaxis_title="Salary",
    font={"family": 'monospace', "size": 16},
    margin={"l": 50, "r": 50, "t": 50, "b": 100},
    legend={
	"orientation": 'h',
	"yanchor": 'top',
	"y": -0.3,
	"xanchor": 'center',
	"x": 0.5
    },
    height=800
)

# Display the plot
fig.show()
