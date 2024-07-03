%pip install plotly pandas

import pandas as pd
import plotly.graph_objs as go
import locale

locale.setlocale(locale.LC_ALL, 'en_US.UTF-8')

df = pd.read_csv('~/git/cleberg.net/static/salary.csv')

# Function to format salary as US currency
def format_currency(value):
    return f"${value:,.2f}"

# Reverse the order of the DataFrame
df = df.iloc[::-1].reset_index(drop=True)

# Calculate the percentage increase
df['Percentage Increase'] = df['Salary'].pct_change() * 100

# Initialize the plot
fig = go.Figure()

# Adding each data point as a separate trace to display the text
for index, row in df.iterrows():
    title_company = f"{row['Title']} ({row['Company']})"
    salary_formatted = format_currency(row['Salary'])
    if pd.notna(row['Percentage Increase']):
        text = f"{salary_formatted} ({row['Percentage Increase']:.2f}%)"
    else:
        text = salary_formatted
    fig.add_trace(go.Scatter(
        x=[row['Start'], row['End']],
        y=[row['Salary'], row['Salary']],
        text=[text],
        mode='lines+text',
        name=title_company,  # Combine title and company for legend
        textposition='top center'
    ))

fig.update_layout(
    title="Salary Data Over Time (annualized)",
    xaxis_title="Time",
    yaxis_title="Salary",
    font=dict(
        family="monospace",
        size=16
    ),
    margin=dict(l=50, r=50, t=50, b=100),  # Adjust bottom margin for legend space
    legend=dict(
        orientation="h",  # Horizontal orientation
        yanchor="top",    # Anchor to the top of the legend box
        y=-0.3,           # Position below the graph
        xanchor="center", # Center the legend horizontally
        x=0.5             # Center the legend
    ),
    height=800  # Increase vertical size
)

fig.show()
