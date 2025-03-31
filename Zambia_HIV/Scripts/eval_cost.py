import os
import json

import matplotlib.pyplot as plt
import numpy as np
import seaborn as sns


# Set working directory
os.chdir("/Users/mduprey/Documents/EMOD/Zambia_HIV/output/")

with open("InsetChart.json") as f:
  data = json.load(f)

sns.set_style("darkgrid")
plt.plot(data["Channels"]["Campaign Cost"]["Data"])
plt.show()