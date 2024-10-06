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
            className="relative rounded-lg p-4 font-mono text-sm bg-zinc-700 md:w-8/12"
            onMouseEnter={() => setIsHovered(true)}
            onMouseLeave={() => setIsHovered(false)}
        >
            <div className="flex justify-center items-center h-full">
                <code>{command}</code>
            </div>
            {isHovered && (
                <button
                    onClick={copyToClipboard}
                    className="absolute top-1/2 right-4 transform -translate-y-1/2 bg-gray-700 rounded-md hover:bg-gray-600 hidden md:block"
                    aria-label="Copy to clipboard"
                >
                    {isCopied ? (
                        <Check className="w-4 h-4 text-green-400"/>
                    ) : (
                        <Copy className="w-4 h-4"/>
                    )}
                </button>
            )}
        </div>
    );
};

export default InstallCommand;