/** * Vercel Serverless Function - 智谱AI代理 * 将前端请求转发到智谱AI API（解决CORS问题） * * 使用模型：GLM-4-Flash（完全免费） * 注册地址：https://open.bigmodel.cn */

module.exports = async function handler(req, res) {
  // 只允许 POST 请求
  if (req.method !== "POST") {
    return res.status(405).json({ error: "Method Not Allowed" });
  }

  try {
    const body = req.body;

    // API Key 优先级：请求体 > 环境变量 > 内置默认值
    const apiKey =e021d768491341889ed2988981f71fca.Xw0f16sAz6ehjCXt
      body.api_key ||
      process.env.ZHIPU_API_KEY ||
      "e021d768491341889ed2988981f71fca.Xw0f16sAz6ehjCXt";

    if (!apiKey) {
      return res.status(400).json({ error: "缺少 API Key" });
    }

    // 构建发送给智谱AI的请求
    const zhipuPayload = {
      model: body.model || "glm-4-flash",
      messages: body.messages || [],
      temperature: body.temperature || 0.7,
      max_tokens: body.max_tokens || 2000,
      top_p: body.top_p || 0.7,
    };

    // 调用智谱AI API
    const zhipuRes = await fetch(
      "https://open.bigmodel.cn/api/paas/v4/chat/completions",
      {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${apiKey}`,
        },
        body: JSON.stringify(zhipuPayload),
      }
    );

    if (!zhipuRes.ok) {
      const errData = await zhipuRes.json().catch(() => ({}));
      return res.status(zhipuRes.status).json({
        error:
          errData.error?.message || `智谱AI API请求失败: ${zhipuRes.status}`,
      });
    }

    const data = await zhipuRes.json();
    return res.status(200).json(data);
  } catch (err) {
    console.error("智谱AI代理错误:", err);
    return res.status(500).json({ error: "代理服务器内部错误" });
  }
};
