import {
    Chart as ChartJS,
    CategoryScale,
    LinearScale,
    PointElement,
    BarElement,
    Title,
    Tooltip,
    Legend,
  } from 'chart.js';
import { Bar } from 'react-chartjs-2';

ChartJS.register(
    CategoryScale,
    LinearScale,
    PointElement,
    BarElement,
    Title,
    Tooltip,
    Legend
  );
const BarGraphics = () => {

    const Options = {
        responsive: true,
        plugins: {
          legend: {
            position: 'top',
          },
          title: {
            display: true,
            text: 'Chart.js Line Chart',
          },
        },
      };
      
    const labels = ['January', 'February', 'March', 'April', 'May', 'June', 'July'];
      
    const Data = {
        labels,
        datasets: [
          {
            label: 'Dataset 1',
            data: [1,2,3,4,5,6,7,8,9,10],
            backgroundColor: 'rgba(255, 99, 132, 0.5)',
          },
          {
            label: 'Dataset 2',
            data: [3,8,2,6,5,9,1,10,9,15],
            backgroundColor: 'rgba(255, 99, 132, 0.5)',
          },
        ],
      };
    return(
        <>
           <Bar data={Data} options={Options}/>
        </>
    );
}

export default BarGraphics