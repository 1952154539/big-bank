# BigBank - Solidity 银行合约

基于 Bank 合约扩展的 Solidity 银行系统，包含接口、继承、权限控制等练习。

## 合约架构

```
IBank  (接口)
  ↑
Bank   (实现 IBank)
  ↑
BigBank (继承 Bank)
```

### 独立合约

- `Admin` - 管理员合约，可从 `IBank` 合约提取资金

## 合约说明

### IBank 接口
定义了银行合约的标准接口：
- `deposit()` - 存款
- `withdraw(uint256 amount)` - 取款（仅管理员）
- `getContractBalance()` - 查看合约余额
- `getTopDepositors()` - 查看前三大储户
- `balances(address)` - 查看用户余额

### Bank 合约
实现 `IBank` 的基础银行合约：
- 部署者自动成为管理员
- 支持存款（含 ETH 直接转入）
- 管理员可提取合约内全部资金
- 维护存款排行榜（Top 3）

### BigBank 合约
继承自 `Bank`，扩展功能：
- **最低存款限制**：存款金额必须 > 0.001 ETH（通过 `minimumDeposit` 修饰器控制）
- **管理员转移**：支持将管理员权限转移给其他地址

### Admin 合约
独立的合约管理员：
- 拥有自己的 `owner`
- `adminWithdraw(IBank bank)` - 调用 `IBank` 的 `withdraw` 方法，将指定 bank 合约的资金转移到 `Admin` 合约地址
- `withdrawAll()` - 合约 owner 提取 `Admin` 合约内的资金

## Remix 部署与测试

### 部署步骤

1. 将所有 `.sol` 文件导入 Remix
2. 编译（Solidity ^0.8.20）
3. 部署 `BigBank` 合约
4. 部署 `Admin` 合约

### 测试流程

1. **转移管理员权限**：在 `BigBank` 合约调用 `transferAdmin`，传入 `Admin` 合约地址
2. **模拟用户存款**：使用不同地址向 `BigBank` 存款（每笔 > 0.001 ETH）
3. **Admin 提取资金**：使用 `Admin` 合约的 `owner` 地址调用 `adminWithdraw(BigBank地址)`，将 `BigBank` 的资金转移到 `Admin` 合约
4. **Owner 提现**：调用 `Admin` 的 `withdrawAll()`，将资金提取到 `owner` 地址

## 版本

- Solidity `^0.8.20`
