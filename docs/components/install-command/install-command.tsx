import { useState } from 'react';
import { Copy, Check } from 'lucide-react';

interface InstallCommandProps {
    command: string;
}

const InstallCommand = ({ command }: InstallCommandProps) => {
    const [isCopied, setIsCopied] = useState(false);
    const [isHovered, setIsHovered] = useState(false);

    const copyToClipboard = async () => {
        try {
            await navigator.clipboard.writeText(command);
            setIsCopied(true);
            setTimeout(() => setIsCopied(false), 2000);
        } catch (err) {
            console.error('Failed to copy text: ', err);
        }
    };

    return (
        <div
            className="relative flex items-center justify-between bg-gray-800 text-white rounded-lg p-4 font-mono text-sm"
            onMouseEnter={() => setIsHovered(true)}
            onMouseLeave={() => setIsHovered(false)}
        >
            <code>{command}</code>
            {isHovered && (
                <button
                    onClick={copyToClipboard}
                    className="ml-2 p-2 bg-gray-700 rounded-md hover:bg-gray-600 transition-colors duration-200"
                    aria-label="Copy to clipboard"
                >
                    {isCopied ? (
                        <Check className="w-4 h-4 text-green-400" />
                    ) : (
                        <Copy className="w-4 h-4" />
                    )}
                </button>
            )}
        </div>
    );
};

export default InstallCommand;