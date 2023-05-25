import { Container } from "reactstrap";
import NavMenu from "./NavMenu";

const Layout = ({ children }) => {
  //static displayName = Layout.name;

  return (
    <div>
      <NavMenu />
      <Container>{children}</Container>
    </div>
  );
};

export default Layout;
