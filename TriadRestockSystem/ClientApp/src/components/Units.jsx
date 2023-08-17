import { Tabs } from 'antd'
import ItemsType from './TypesForms/ItemsType';
import UnitType from '../components/TypesForms/UnitType'

const Units = () => {
      const onChange = (key) => {
        console.log(key);
      };
      const items = [
      {
        key: '1',
        label: `Tipo de articulos`,
        children: <ItemsType/>,
      },
      {
        key: '2',
        label: `Unidad de medida`,
        children: <UnitType/>,
      }
    ];
    return(
        <>
         <Tabs defaultActiveKey="1" items={items} onChange={onChange} />
        </>
    );
}
export default Units