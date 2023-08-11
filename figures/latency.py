import seaborn as sns
import matplotlib.pyplot as plt
import pandas as pd

def import_data(file_name):
    return pd.read_csv(file_name)

def plot_data(df, plot_type):
    sns.set(style = "whitegrid")
    plt.figure(figsize = (10, 6))

    if plot_type == 'pdf':
        sns.kdeplot(df['Runtime'], bw_adjust=0.5, fill=True)
        plt.title('Probability Density Function of Runtime')
    elif plot_type == 'cdf':
        sns.kdeplot(df['Runtime'], cumulative=True, bw_adjust=0.5, fill=True)
        plt.title('Cumulative Distribution Function of Runtime')
    else:
        print('Invalid plot type. Please choose "pdf" or "cdf".')

    plt.xlabel('Runtime')
    plt.ylabel('Density' if plot_type == 'pdf' else 'Cumulative')

    plt.savefig('runtime_amazon_one_day.pdf')


def main():
    file_name = '../benchmark/amazon/TPCDS_one_day_runtime.csv' # input your file name here
    df = import_data(file_name)
    plot_type = 'pdf' # choose either 'pdf' or 'cdf'
    plot_data(df, plot_type)



if __name__ == "__main__":
    main()