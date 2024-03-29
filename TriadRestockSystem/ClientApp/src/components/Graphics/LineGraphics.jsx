import {
    Chart as ChartJS,
    CategoryScale,
    LinearScale,
    PointElement,
    LineElement,
    Title,
    Tooltip,
    Legend,
  } from 'chart.js';
import { Line } from 'react-chartjs-2';

ChartJS.register(
    CategoryScale,
    LinearScale,
    PointElement,
    LineElement,
    Title,
    Tooltip,
    Legend
  );
const LineGraphics = () => {

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
            borderColor: 'rgb(255, 99, 132)',
            backgroundColor: 'rgba(255, 99, 132, 0.5)',
          },
        ],
      };
    return(
        <>
           <Line data={Data} options={Options}/>
        </>
    );
}

export default LineGraphics